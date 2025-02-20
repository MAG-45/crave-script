#!/bin/bash

# Remove old local manifests
rm -rf .repo/local_manifests/

# Init ROM manifest
repo init -u https://github.com/Evolution-X/manifest -b vic --git-lfs

# Download duchamp manifests
git clone https://github.com/MAG-45/evox_manifest_duchamp .repo/local_manifests

# Patch EvolutionX manifest
sed -i '/<project path="hardware\/lineage\/compat" name="LineageOS\/android_hardware_lineage_compat" \/>/d' .repo/manifests/snippets/lineage.xml

# Copy singins keys 
cp keys/* vendor/evolution-priv/keys

# Remove problematic tree 
rm -rf hardware/lineage/compat/

# Patch FP Sensors
cd frameworks/base
curl -s https://raw.githubusercontent.com/xiaomi-mt6897-duchamp/patches/refs/heads/main/0001-biometrics-virtualhal-Revert-for-mfp-daemon-to-work.patch -s | git am
cd ../..

# Crave sync 
/opt/crave/resync.sh

# Start building
. build/envsetup.sh

lunch lineage-duchamp_apa4_userdebug

m evolution
