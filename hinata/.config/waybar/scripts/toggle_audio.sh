#!/bin/bash

# if you randomly find this, you need to use pactl list short sinks to find your correct targets. then replace values for speakers and headphones

speakers='alsa_output.pci-0000_12_00.6.analog-stereo'
headphones='alsa_output.usb-SteelSeries_Arctis_Nova_7-00.analog-stereo'

activesink=$(pactl get-default-sink)

if [ "$activesink" = "$headphones" ]; then
    pactl set-default-sink "$speakers"
else
    pactl set-default-sink "$headphones"
fi
