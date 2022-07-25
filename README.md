king solomon was punk rock awesome. but at the end of 2019 i met [someone](https://github.com/AriaSalvatrice) much more magic. she programmed (among many other cool things) the [Modulus Salomonis Regis](https://aria.dog/modules/). its powers were infinite, its possibilities endless, but the platform on which it ran.. ah, that's a long story...


now i'm learning magic:

- i try to follow the csound backwards compatibility philosophy here, so newer things are added without breaking old code
- there's usually a documentation string with each opcode's definition
- things are never perfect
- above all, have fun (someone on the csound discord had that as a status and i love it)

#### taphath.orc
tries to mimick Aria's MSR as much as possible, but it's missing the queue/teleport triggers. it's an arbitrary-length, self-modulating, pitch-quantized sequencer. (this is how it all started)

#### basemath.orc
is the same idea applied to rhythm, an arbitrary-length, self-modulating rhythm sequencer. (use `tBasemath` to avoid issue #15)

#### tbasemath.orc
is an external-trigger-driven `Basemath`


#### taphy.orc and basma.orc
(modified Taphath and tBasemath) are new versions without the modulation array inputs. All control is done from the calling instrument. They're a bit more effecient, and allow for more control (actually they just force you to use a certain way of sequence modulation which gives more control!)


#### mycorrhiza.orc
recently seen a tweet by Mog and went: "hey i miss that cute sequencer!" and 20 days later, here we are! this one tries to mimick Mog's [Network](https://github.com/JustMog/Mog-VCV) sequencer

so lucky to have met you all 💜

(for now jam-59 and above are using mycorrhiza, so that's where examples are at)

#### jam/
Music/sounds, check them out for examples.

#### utils.orc
clock dividers, shift registers, 2d array utils, you name it! (they're a big flaming mess though)

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

---
in the discussions tab there's links to gravity break and soundcloud if you wanna check some of my jams

If you make something with these, I'd love love love to have a listen/look! Also if you find anything confusing please feel free to open a discussion or an issue 💜

###### Made using [Vim](https://www.vim.org/) and [Csound](https://csound.com/) installed on a [Fedora](https://fedoraproject.org/) ([Void](https://voidlinux.org/) now) proot on [Termux](https://termux.com/) on an android oreo phone, void of any analog warmth! [[setup recipe]](https://github.com/tomara-x/csound-proot-distro-recipe)


💜
