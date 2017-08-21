# enable Software Collections following https://access.redhat.com/solutions/527703
for sclname in rh-python35 devtoolset-6; do
    source scl_source enable $sclname &> /dev/null || true
done