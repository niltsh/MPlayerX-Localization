MPlayerX-Localization instruction
=============
INTRO
-------
Welcome to MPlayerX-Localization Project.
This is a sub-project of MPlayerX, which is a open-source media player project on Mac OS X. You could take a look at http://github.com/niltsh/MPlayerX
This is the document will help you to understand how to make a localization package of MPlayerX.
There is also a avn repo at http://code.google.com/p/mplayerx-localization/ and this git repo was started at r50 of the svn repo.

REPO STRUCTURE
-------
┬─ root
├┬─ 1.0.0
│├─ English.lproj
│└─ zh_CN.lproj
├┬─ 1.0.1
│├─ English.lproj
│└─ zh_CN.lproj
├── ...

BASIC WORKFLOW
-------
1. With every release, the [version number] folder will be created in the root.
2. The MASTER lproj is English.lproj, [the project owner] will upload this lproj when the UI is finalized for every release.
3. Basically, English.lproj will be uploaded only ONCE for every release. But there might be some incidence that [the project owner] have to update English.lproj.
4. Every time the English.lproj was uploaded or updated, [the project owner] should email to all the contributors.
5. The notification email should include
  * what were uploaded or updated.
  * the branch in the MPlayerX repo for this update
  * the version number in the MPlayerX repo for this update
6. After received the email, the contributors could start the work any time(if not too late
7. Except [the project owner], It is PROHIBITED for contributors to modify any files in English.lproj.
8. Contributors could create any files or folders for their own localization.
9. Since the lproj folder has naming rules, if not known, please look into http://developer.apple.com/mac/library/documentation/MacOSX/Conceptual/BPInternational/Articles/LanguageDesignations.html
10.There are two sorts of files contributors could upload or update, .xib or .strings.
  * `xib should be the raw, editable xib files. please DO NOT upload the compiled nib files.`
  * `strings should be encoded by UTF-16.`
11.When contributors is going to finish the localization, there are two ways to let [the project owner] know.
  * email to [the project owner]
  * write some commit messages in the final commit.(PLEASE use English, rather than you own language, in the final commit)
12.Contributors should be responsible for the test, [the project owner] may know nothing about the specific language.
13.Finally, localization is really a lengthy job and need much much carefulness and patience.
   `I really appreciate your help and`
   `THANK YOU VERY VERY MUCH.`

USAGE OF MAKEFILE
-------
There is a template.Makfile in localization/ , you could make the necessary lproj files with just a make command
1. copy the `temple.Makefile` to [version number] folder
2. rename it to `Makefile`
3. in Terminal, goto the [version number] folder
4. `make`
5. the compiled lprojs will be placed in the results/

INFO
-------
2010/06/08 - now  [the project owner] = Zongyao QU, zongyao.qu@gmail.com

Appendix
-------
* How to make a increment localization
  * For strings file
    There is no better way.
    Just use a difftool(such as FileMerge.app) to compare the latest untranslated file with the last version,
    then merge the items you have translated.
  * For xib files
    Before start to translate, you could run this command to transfer your previous work to the new one.
    `ibtool --previous-file {old master}/MyNib.nib --incremental-file {old translated}/MyNib.nib --localize-incremental --write {new translated}/MyNib.nib {new master}/MyNib.nib`

* For more info about how to localize to another language, please read
  * The basic concepts
    http://developer.apple.com/mac/library/documentation/MacOSX/Conceptual/BPInternational/BPInternational.html
  * The toolchain
    http://developer.apple.com/mac/library/documentation/DeveloperTools/Conceptual/IB_UserGuide/LocalizingNibFiles/LocalizingNibFiles.html
    `man ibtool`
    `man genstrings`
