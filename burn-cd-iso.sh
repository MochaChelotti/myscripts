#!/bin/sh -x
cdrecord -v -eject speed=16 dev=/dev/hdc fs=8m $1
