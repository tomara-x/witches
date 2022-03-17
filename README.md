# Witches

King Solomon was punk rock awesome! He made the ultimate sequencer, it used magic to make music. (trust me)

At the end of 2019 I met [his successor](https://github.com/AriaSalvatrice) in awesomeness. She programmed (among many other 🆒 things) the [Modulus Salomonis Regis](https://aria.dog/modules/). Its powers were infinite, its possibilities endless, but the platform on which it ran.. Ah, that's a long story...

Months after i lost my favorite instrument, i missed the magic, so i did this:

### sequencers.orc
(full documentation in file)

- `Taphath` tries to mimick Aria's MSR as much as possible. (with just a few quirks) It's an arbitrary-length, self-modulating, pitch-quantized[^1] sequencer. (this is how it all started)

- `Basemath` is the same idea applied to rhythm,  an arbitrary-length, self-modulating rhythm sequencer. (use `tBasemath` to avoid issue #15)

- `tBasemath` is an external-trigger-driven `Basemath`.

- `uTaphath`, `uBasemath`, and `utBasemath` are minimal versions.

### mixer.orc
Sterio audio bus/mixer from the [csound-live-code](https://github.com/kunstmusik/csound-live-code) library by Steven Yi with a few additions for my uses.

### utils.orc
Utilities for working with the ladies.

### oscillators.orc
A pretty nice phase modulation oscillator opcode. (for now)

### jam/
Music/sounds check them out for examples.

### fm/
FM algorithms fun

### demon/
running csound in daemon mode for live coding

### other files
old stuff i don't use anymore (to keep dependant files working) or just me playing around, experimenting and stuff

Here's my [soundcloud](https://soundcloud.com/nope-null) where you can find some renders of some of the files here.

If you make something with these, I'd love love love to have a listen/look! Also if you find anything confusing please feel free to message me 💜

###### Made using [Vim](https://www.vim.org/) and [Csound](https://csound.com/) installed on a [Fedora](https://fedoraproject.org/) ([Void](https://voidlinux.org/) now) proot on [Termux](https://termux.com/) on an android (version 8.1) phone, void of any analog warmth! (except for that fm diagram, i drafted that on paper!) [[setup recipe]](https://github.com/tomara-x/csound-proot-distro-recipe)


💜

[^1]: When used with a [GEN51](https://csound.com/docs/manual/GEN51.html) function table.
[^2]: whatever that means!
