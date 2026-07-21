
# Show the /Volumes folder
chflags nohidden /Volumes

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
mdutil -i on / > /dev/null
# Rebuild the index from scratch
mdutil -E / > /dev/null
