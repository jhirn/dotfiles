function forward_vm_port -d "add port forwarding rule for boot2coker's vm"
        VBoxManage modifyvm "dev" --natpf1 "tcp-port$1,tcp,,$1,,$1";
        VBoxManage modifyvm "dev" --natpf1 "udp-port$1,udp,,$1,,$1";
end
