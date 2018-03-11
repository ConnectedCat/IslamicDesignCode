#!/bin/sh
ffmpeg -f image2 -i output-%4d.png -pix_fmt yuv420p -r 12 output_12fps.mov