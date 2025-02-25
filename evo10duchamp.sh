#!/bin/bash

# Remove old local manifests
rm -rf .repo/local_manifests/
echo "Remove local manifests"

# Init ROM manifest
repo init -u https://github.com/Evolution-X/manifest -b vic --git-lfs
echo "Init EvoX Manifest"

# Download duchamp manifests
git clone https://github.com/MAG-45/evox_manifest_duchamp .repo/local_manifests
echo "Clone manifests for duchamp"

# Patch EvolutionX manifest
sed -i '/<project path="hardware\/lineage\/compat" name="LineageOS\/android_hardware_lineage_compat" \/>/d' .repo/manifests/snippets/lineage.xml
# Remove problematic tree 
rm -rf hardware/lineage/compat/
echo "Patch lineage manifest"

# Patch FP Sensors
cd frameworks/base
curl -O https://raw.githubusercontent.com/MAG-45/duchamp_patch/refs/heads/vic_evo/fp_evo.patch
git am < fp_evo.patch
cd ../..
echo "###########################"
echo "####FP PATCHING############"
echo "###########################"

# Crave sync 
/opt/crave/resync.sh

# Start building
. build/envsetup.sh

lunch lineage_duchamp-ap4a-userdebug

m evolution
