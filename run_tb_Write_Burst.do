vlog Top.v TB.v
vsim work.TB -voptargs=+acc
add wave Hclk Hresetn Haddr HWdata Hwrite Hreadyin Htrans Pwrite PWdata_out -position insertpoint
run -all
wave zoom full
radix -binary -showbase
radix signal sim:/TB/Hclk unsigned -showbase
radix signal sim:/TB/Hresetn unsigned -showbase
radix signal sim:/TB/Haddr hexadecimal -showbase
radix signal sim:/TB/HWdata hexadecimal -showbase
radix signal sim:/TB/Hwrite unsigned -showbase
radix signal sim:/TB/Hreadyin unsigned -showbase
radix signal sim:/TB/Htrans unsigned -showbase
radix signal sim:/TB/Pwrite unsigned -showbase
radix signal sim:/TB/PWdata_out hexadecimal -showbase