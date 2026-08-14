clang -target aarch64-unknown-windows-msvc -c core.asm -o core.obj
lld-link -subsystem:efi_application -entry:main core.obj -out:core.efi

qemu-system-aarch64.exe -M virt -cpu cortex-a57 -m 512M -nographic -kernel core.efi