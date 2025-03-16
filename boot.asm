; boot.asm
[org 0x7c00]

; 그래픽 모드 0x13 설정 (320x200, 256 colors)
mov ax, 0x0013
int 0x10

KERNEL_OFFSET equ 0x1000

; 부트 드라이브 번호 저장
mov [BOOT_DRIVE], dl

xor ax, ax
mov es, ax
mov ds, ax
mov ss, ax
mov sp, 0x7c00

mov bx, KERNEL_OFFSET
mov dh, 2        ; 커널은 2번째 섹터부터 읽음
mov dl, [BOOT_DRIVE]
call load_kernel

jmp KERNEL_OFFSET

load_kernel:
    mov ah, 0x02
    mov al, 15       ; 최대 15섹터 (약 7.5KB) 읽기
    mov ch, 0
    mov cl, 2        ; 섹터 번호 2부터
    mov bx, KERNEL_OFFSET
    int 0x13
    jc disk_error
    ret

disk_error:
    ; 그래픽 모드에서는 텍스트 출력이 어려우므로 무한루프로 대기
    jmp $

BOOT_DRIVE db 0

times 510 - ($ - $$) db 0
dw 0xaa55
