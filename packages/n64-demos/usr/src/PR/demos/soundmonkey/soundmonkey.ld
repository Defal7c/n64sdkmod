OUTPUT_ARCH (mips)

#define BEGIN_SEG(name, addr) \
    _##name##SegmentStart = ADDR(.name); \
    _##name##SegmentRomStart = __romPos; \
    .name addr : AT(__romPos)

#define END_SEG(name) \
    _##name##SegmentEnd = ADDR(.name) + SIZEOF(.name); \
    _##name##SegmentRomEnd = __romPos + SIZEOF(.name); \
    __romPos += SIZEOF(.name);

#define BEGIN_NOLOAD(name) \
    _##name##SegmentBssStart = ADDR(.name.noload); \
    .name.noload (NOLOAD) :

#define END_NOLOAD(name) \
    _##name##SegmentBssEnd = ADDR(.name.noload) + SIZEOF(.name.noload); \
    _##name##SegmentBssSize = SIZEOF(.name.noload);

SECTIONS
{
   __romPos = 0;

   BEGIN_SEG(boot, 0x04000000)
   {
      asm/rom_header.o(.text);
      boot.6102.o(.data);
   }
   END_SEG(boot)

   BEGIN_SEG(code, 0x80000400) SUBALIGN(16)
   {
      asm/entry.o(.text);
      codesegment.o(.text);
      /usr/lib/n64/PR/rspboot.o(.text);
      /usr/lib/n64/PR/aspMain.o(.text);

      /* data */
      codesegment.o(.data*);
      /usr/lib/n64/PR/rspboot.o(.data*);
      /usr/lib/n64/PR/aspMain.o(.data*);

      /* rodata */
      codesegment.o(.rodata*);
   }
   END_SEG(code)
   BEGIN_NOLOAD(code)
   {
      codesegment.o(COMMON);
      codesegment.o(.scommon*);
      codesegment.o(.bss*);
      . = ALIGN(0x8);
   }
   END_NOLOAD(code)
   
   BEGIN_SEG(seq, __romPos)
   {
      /usr/lib/n64/sequences/ship.sbk.o(.data);
      . = ALIGN(0x10);
   }
   END_SEG(seq)
   
   BEGIN_SEG(sfxbank, __romPos)
   {
      /usr/lib/n64/soundbanks/sfx.ctl.o(.data);
      . = ALIGN(0x10);
   }
   END_SEG(sfxbank)
   
   BEGIN_SEG(sfxtable, __romPos)
   {
      /usr/lib/n64/soundbanks/sfx.tbl.o(.data);
      . = ALIGN(0x10);
   }
   END_SEG(sfxtable)
   
   BEGIN_SEG(midibank, __romPos)
   {
      /usr/lib/n64/soundbanks/GenMidiBank.ctl.o(.data);
      . = ALIGN(0x10);
   }
   END_SEG(midibank)
   
   BEGIN_SEG(miditable, __romPos)
   {
      /usr/lib/n64/soundbanks/GenMidiBank.tbl.o(.data);
      . = ALIGN(0x10);
   }
   END_SEG(miditable)

   /* Discard everything not specifically mentioned above. */
   /DISCARD/ :
   {
      *(*);
   }
}
