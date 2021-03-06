#!/bin/bash

# Define a list of words v2.0 by ctrezevant
# For those times where you're looking for an easy way to automate the process of looking up definitions.
# Distribute/use this freely as long as you give me (charlton trezevant) and linuxtidbits.wordpress.com credit.
# GitHub page: https://github.com/ctrezevant/define-a-list-of-words

# takes a list of words in words.txt and outputs them, along with their definitions, to definitions.txt

# Make sure you install sdcv and get the StarDict dictionary loaded before running this:
# Tutorial for loading StarDict:
# http://linuxtidbits.wordpress.com/2008/01/30/command-line-dictionary/
# Link to download StarDict:
# http://abloz.com/huzheng/stardict-dic/dict.org/

# I hope this tool is useful to you!

# read words per new line
IFS='
'

# Program name from it's filename
prog=${0##*/}

# Text color variables
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #     red
bldwht=${txtbld}$(tput setaf 7) #     white
txtrst=$(tput sgr0)             # Reset
warn=${bldred}!${txtrst}

sedbldwht='\c[[1;37m'           # Sed white  - bold
sedtxtrst='\c[[0m'              #     text reset

# Start the main loop.
for line in $(cat words.txt); do

wordchecknum=$(echo "$line" | aspell -a | sed '1d' | wc -m)
wordcheckprnt=$(echo "$line" | aspell -a | sed '1d' | sed 's/^.*: //')

# Formatting for messages sent to stdout.
echo ' '
echo "The next word to define is $line"
# Formatting for definitions.
echo ' ' >>definitions.txt
echo ' ' >>definitions.txt
# Print the definition of that word to the file.
sdcv -n -u "WordNet" --utf8-input --utf8-output "$line" | sed '1,3d' | sed '/^*$/d' | sed "h; :b; \$b ; N; /^${1}\n     n/ {h;x;s// ${sedbldwht}Noun${sedtxtrst}\n/; bb}; \$b ; P; D" | sed "h; :b; \$b ; N; /^     v/ {h;x;s// ${sedbldwht}Verb${sedtxtrst}\n/; bb}; \$b ; P; D" | sed "h; :b; \$b ; N; /^     adv/ {h;x;s// ${sedbldwht}Adverb${sedtxtrst}\n/; bb}; \$b ; P; D" | sed "h; :b; \$b ; N; /^     adj/ {h;x;s// ${sedbldwht}Adjective${sedtxtrst}\n/; bb}; \$b ; P; D" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" >>definitions.txt
done

# Print a bunch of messages to stdout.
echo ' '
echo 'All done!'
echo 'Definitions saved to definitions'
echo 'Have a great day!'

exit
