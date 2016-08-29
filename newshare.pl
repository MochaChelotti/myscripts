#!usr/bin/perl -w
##############################################################################
#
# Example script to create a share
#
##############################################################################

use strict;
BEGIN
{
   require exagrid::core::Globals;
   require exagrid::core::Commandline;
   require exagrid::output::Tracelog;
   require exagrid::core::Util;
   require exagrid::product::Share;
};

################################################################################
##
## CONSTANTS
##
################################################################################

# Maximum number of times to try creating a share
use constant MAX_CREATION_ATTEMPTS => 3;

# Number of seconds to sleep betwen attempts
use constant SLEEP_SECONDS => 180;

################################################################################
##
## GLOBALS
##
################################################################################

# Grid Net IP address or other ID of the filer on which we create the share
my $filerId;

# Name of the share to be created
my $shareName;

# Type (unchecked) of the share to be created
my $shareType;

# List of address/mask pairs to be used for white-list entries
my @whitelist = ();

# Object corresponding to our parsed command line
my $commandLine;

################################################################################
##
## COMMAND LINE ARGUMENTS
##
################################################################################

my $PROGRAM =
{
   OneLiner             => "Example Share Creation Script",
   Description          => [ "This script creates a single share on a remote grid's sever" ],
   SupportDryRun        => 1,
   RequireLoginString   => 1,
   Plugins              => [ "UIHost" ],
   Arguments            =>
      [
       {
          Keyword          => "FilerID",
          Description      => "ID of the filer on which we create the share",
          Required         => 1,
          Reference        => \$filerId,
       },
       {
          Keyword          => "Name",
          Description      => "Name of the share to be created",
          Required         => 1,
          Reference        => \$shareName,
       },
       {
          Keyword          => "Type",
          Description      => "Type of the share to be created; note that this is not verified",
          Default          => "BackupExec",
          DefaultInHelp    => 1,
          Reference        => \$shareType,
       },
       {
          Keyword          => "WhiteList",
          Description      => "IP address / mask string, as in 172.21.0.118/255.255.255.0",
          Required         => 1,
          Reference        => \@whitelist,
       },
      ],
};

################################################################################
##
## ROUTINES
##
################################################################################

## @fn exagrid::product::Share createShare( $filerIp, $shareName, $shareType, $whiteListRef, %options )
#
# Create a CIFS share with a given name, type, and white-list on a filer.
#
# @param $filerIP GridNet IP address of the Server on which we create the share
# @param $shareName name of the share to be created
# @param $shareType type of the share to be created
# @param $whiteListRef reference to a list of address/mask string (ie: 172.21.0.118/255.255.255.0)
# @param %options options that control different aspects of this function:
# - uiHost ID of the grid machine to which we direct any P2P messages, defaults to $filerIp
# - port port on the uiHost to which we direct our messages, defaults to 80
# @return a reference to a new share, or undef if we cannot create one
#
sub createShare( $$$$;% )
{
   my $filerIp      = shift;
   my $shareName    = shift;
   my $shareType    = shift;
   my $whiteListRef = shift;
   my %options      = @_;
   exagrid::output::Tracelog::traceIn( "( $filerIp, $shareName, $shareType, $whiteListRef, ",
                                       exagrid::core::Options::toString( \%options ), " )" );

   # Create a new share object and then set the type and a generous whitelist
   my $share = new exagrid::product::Share( %options,
                                            filer     => $filerIp,
                                            shareName => $shareName,
                                            new       => 1 );
   $share->setAttributesType( $shareType );

   $share->setShareShareType( "cifs" );
   $share->setShareShareEnable( "yes" );

   # New shares come with an empty exagrid::product::share::WhiteList object to which you can add
   # multiple entries
   foreach my $oneAddrAndMask ( @$whiteListRef )
   {
      $share->getChild( "WhiteList" )->addChild( { addrAndMask => $oneAddrAndMask } );
   }

   # List out white list entries just to show how it can be done.  Note that a whitelist is an
   # instance of an exagrid::parser::Collection object.
   my $whiteList = $share->getChild( "WhiteList" );
   exagrid::output::Tracelog::verbose1Log( "Number of whitelist entries: " . $whiteList->getChildCount() . "\n" );
   foreach my $oneWhiteListEntry ( $whiteList->getChildren() )
   {
      exagrid::output::Tracelog::verbose1Log( "  " . $oneWhiteListEntry->toXml->toString() );
   }

   # Put the fist whitelist entry at the end of the list just to show how it can be done
   my $firstChild = $whiteList->getChild( 0 );
   $whiteList->deleteChild( $firstChild );
   $whiteList->addChild( $firstChild );

   exagrid::output::Tracelog::verbose1Log( "Number of whitelist entries: " . $whiteList->getChildCount() . "\n" );
   foreach my $oneWhiteListEntry ( $whiteList->getChildren() )
   {
      exagrid::output::Tracelog::verbose1Log( "  " . $oneWhiteListEntry->toXml->toString() );
   }

   # Create the actual share
   if( !$exagrid::core::Globals::dryRunMode )
   {
      # Try a few times to create the share
      my $maxTries = MAX_CREATION_ATTEMPTS;
      while( !$share->isValid() && $maxTries-- > 0 )
      {
         exagrid::output::Tracelog::logOutput ("Creating share $shareName on $filerIp via " .
                                               $commandLine->pluginsToTag( "UIHost" ) . "...\n");
         if( !$share->create( waitForOnline => 1 ) )
         {
            if( $maxTries > 0 )
            {
               exagrid::output::Tracelog::warningOutput( "Cannot create the share $shareName on $filerIp, " .
                                                         "retrying again after a while...\n" );
               exagrid::core::Util::snooze( SLEEP_SECONDS, exagrid::Enum::verbosity::VERBOSE2 );
            }
            else
            {
               exagrid::output::Tracelog::errorOutput( "Cannot create the share $shareName on $filerIp via " .
                                                       $commandLine->pluginsToTag( "UIHost" ) . "...\n");
               $share = undef;
            }
         }
      }
   }
   exagrid::output::Tracelog::traceOut( "= " . exagrid::core::Util::safeString( $share ) );
   return $share;
}

################################################################################
##
## MAIN
##
################################################################################

$commandLine = new exagrid::core::Commandline( $PROGRAM );

my $newShare = createShare( $filerId, $shareName, $shareType, \@whitelist,
                            $commandLine->pluginsToOptions( "UIHost" ) );

if( defined( $newShare ) )
{
   exagrid::output::Tracelog::normalLogOutput( "Created share $shareName: ", $newShare->toXml()->toString() );
}
else
{
   exagrid::output::Tracelog::normalLogOutput( "Could not create share $shareName\n" );
}

exit $exagrid::core::Globals::exitCode;
