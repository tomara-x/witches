# Witches

King Solomon was punk rock awesome! He made the ultimate sequencer, it used magic to make music. (trust me)

At the end of 2019 I met [his successor](https://github.com/AriaSalvatrice) in awesomeness. She programmed (among many other cool things) the [Modulus Salomonis Regis](https://aria.dog/modules/). Its powers were infinite, its possibilities endless, but the platform on which it ran.. Ah, that's a long story...

Months after I lost my favorite instrument, I missed the magic, I wanted it in my csound setup, so I made these:

(check the opcodes.orc file for full documentation)
- `Taphath` tries to mimick Aria's MSR as much as possible. (with just a few quirks) It's an arbitrary-length, self-modulating, pitch-quantized[^1] sequencer.

- `Basemath` is an arbitrary-length, self-modulating rhythm sequencer.

- `uTaphath` and `uBasemath` are minimal versions.

### opcodes.orc
That's where the opcode definitions of Taphath and Basemath (and the u versions) are. You can place this in your project directory, #include it in your csd file, and that's it, you have the opcodes ready to use. (It also includes the documentation of the opcodes)

### function-tables.orc
Those are function tables used in my playing files. They're mostly just gen51 musical scales used with `Taphath` You can edit them, define your own, or something else.

### all other files
Those files are just me playing around. Who knows what'll be there! Check them out for examples/seeing the sequencers in action.

Here's my [soundcloud](https://soundcloud.com/nope-null) where you can find some renders of some of the files here.

If you make something with these, I'd love love love to have a listen/look!

###### Made using [Vim](https://www.vim.org/) and [Csound](https://csound.com/) installed on a [Fedora](https://fedoraproject.org/) ([Void](https://voidlinux.org/) now) proot on [Termux](https://termux.com/) on an android (version 8.1) phone, void of any analog warmth! [[setup recipe]](https://github.com/tomara-x/csound-proot-distro-recipe)


💜

[^1]: When used with a [GEN51](https://csound.com/docs/manual/GEN51.html) function table.
