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
git fetch https://github.com/snapboss/android_frameworks_base
git cherry-pick -Xtheirs 53ebff0802f1043f361c699442a982b5b6e7792a   
cd ../..

# Crave sync 
/opt/crave/resync.sh

# Copy singins keys 
mkdir vendor/evolution-priv/keys/ -p
cp keys/* vendor/evolution-priv/keys/
ln -s build/make/target/product/security/BUILD.bazel vendor/evolution-priv/keys/BUILD.bazel
echo "Copy keys"

# Start building
. build/envsetup.sh

lunch lineage_duchamp-apa4-userdebug

m evolution
