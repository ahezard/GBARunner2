.arch	armv5te
.cpu	arm946e-s

.extern gba_setup

.section ".init"
.global _start
.align	4
.arm
_start:
    @ dsi registers configuration
    ldr r0, =0x4004000  @ REG_SCFG_ROM
    
	ldr	r1, =0x081
    str	r1, [r0, #0x4]  @ REG_SCFG_CLK
    
	ldr	r1, =0x83000000
    str	r1, [r0, #0x8]  @ REG_SCFG_EXT 
    @ dsi registers configuration 

	mov	r0, #0x04000000
	str	r0, [r0, #0x208]
	b gba_setup
	
.align
.pool
.end