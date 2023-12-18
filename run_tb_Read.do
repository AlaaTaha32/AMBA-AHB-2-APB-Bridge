vlog Top.v TB.v
vsim work.TB -voptargs=+acc
add wave Hclk Hresetn Haddr HRdata Hwrite Hreadyin Htrans Psel_out Penable_out Pwrite Paddr_out PRdata -position insertpoint
run -all
wave zoom full
radix -binary -showbase
radix signal sim:/TB/Hclk unsigned -showbase
radix signal sim:/TB/Hresetn unsigned -showbase
radix signal sim:/TB/Haddr hexadecimal -showbase
radix signal sim:/TB/HRdata hexadecimal -showbase
radix signal sim:/TB/Hwrite unsigned -showbase
radix signal sim:/TB/Hreadyin unsigned -showbase
radix signal sim:/TB/Htrans unsigned -showbase
radix signal sim:/TB/Psel_out unsigned -showbase
radix signal sim:/TB/Penable_out unsigned -showbase
radix signal sim:/TB/Pwrite unsigned -showbase
radix signal sim:/TB/Paddr_out hexadecimal -showbase
radix signal sim:/TB/PRdata hexadecimal -showbase