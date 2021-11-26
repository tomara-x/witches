# Witches

King Solomon was punk rock awesome! He made the ultimate sequencer, it used magic to make music. (trust me)

At the end of 2019 I met [his successor](https://github.com/AriaSalvatrice) in awesomeness. She programmed (among many other cool things) the [Modulus Salomonis Regis](https://aria.dog/modules/). Its powers were infinite, its possibilities endless, but the platform on which it ran.. Ah, that's a long story...

Months after I lost my favorite instrument, I missed the magic, I wanted it in my csound setup, so I made this.

The opcode `Taphath` tries to mimick Aria's MSR as much as possible. (except for the queue function because I'm too lazy)

`Basemath` is similar but does rhythm instead of pitch/control-signal.

### opcodes.orc
That's where the opcode definitions of Taphath and Basemath are. You can place this in your project directory, #include it in your csd file, and that's it, you have the opcodes ready to use. (It also includes the documentation of the opcodes)

### function-tables.orc
Those are function tables used in the demo file (they're just musical scales) you can edit them, define your own, or something else.

### witches.csd
This is a demo file. These are just examples of ways I'd use the sequencers, but I'd love to see what you'd come up with. (seriously, mail/DM me any wiggly air you make!) Something I haven't tried, but I think would be awesome, is to have multiple instances running in the same instrument at different rates and modulating each other's inputs. Makes my head spin!

###### Made using a [Csound](csound.com/) installed on a [Fedora](fedoraproject.org/) proot on [Termux](termux.com/) on an android phone, void of any analog warmth.

💜
