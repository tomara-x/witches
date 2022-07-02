# Witches

King Solomon was punk rock awesome! He made the ultimate sequencer, it used magic to make music. (trust me)

At the end of 2019 I met [his successor](https://github.com/AriaSalvatrice) in awesomeness. She programmed (among many other 🆒 things) the [Modulus Salomonis Regis](https://aria.dog/modules/). Its powers were infinite, its possibilities endless, but the platform on which it ran.. Ah, that's a long story...

Months after I lost my favorite instrument, I missed the magic, so I did this:

#### sequencers.orc
(full documentation in file)

- `Taphath` tries to mimick Aria's MSR as much as possible. (with just a few quirks) It's an arbitrary-length, self-modulating, pitch-quantized[^1] sequencer. (this is how it all started)

- `Basemath` is the same idea applied to rhythm, an arbitrary-length, self-modulating rhythm sequencer. (use `tBasemath` to avoid issue #15)

- `tBasemath` is an external-trigger-driven `Basemath`.

- `uTaphath`, `uBasemath`, and `utBasemath` are minimal versions.

#### sequencers2.orc
`Taphy` and `Basma` (modified Taphath and tBasemath)
New versions without the modulation array inputs. All control is done from the calling instrument. They're a bit more effecient, and allow for more control (actually they just force you to use a certain way of sequence modulation which gives more control!)

#### jam/
Music/sounds, check them out for examples.

#### demon/
Running csound in server mode for live coding

---
### usage:
1. you'll need csound to execute the files here (grab it at https://csound.com/)
2. you'll want to clone this project:
    - using git: `git clone https://github.com/tomara-x/witches.git`
    - or you can just download the zip (though git is better because you can check for updates and stuff)
3. run whatever files you like by running `csound file.csd` in a command line (you can also run them in a gui frontend like csoundqt)
4. see the [floss manual](https://flossmanual.csound.com/introduction/preface) and the [csound canonical manual](https://csound.com/docs/manual/index.html) for more details about the csound language
5. make some noise and have fun

If you make something with these, I'd love love love to have a listen/look! Also if you find anything confusing please feel free to open a discussion or an issue 💜

###### Made using [Vim](https://www.vim.org/) and [Csound](https://csound.com/) installed on a [Fedora](https://fedoraproject.org/) ([Void](https://voidlinux.org/) now) proot on [Termux](https://termux.com/) on an android (version 8.1) phone, void of any analog warmth! (except for that fm diagram, i drafted that on paper!) [[setup recipe]](https://github.com/tomara-x/csound-proot-distro-recipe)


💜

[^1]: When used with a [GEN51](https://csound.com/docs/manual/GEN51.html) function table.
