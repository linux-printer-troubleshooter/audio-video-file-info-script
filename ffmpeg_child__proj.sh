

populate_info () {
ffmpeg -i "$1" 2>stderr
cat stderr | grep -i stream | awk '{print $2}' | awk -F "(" '{print $1}' | awk -F "#" '{print $2}' >map_story
cat stderr | grep -i stream | awk '{print $3}' | awk -F ":" '{print $1}' >stream_story
}
zenity --info --text="Stream Finder Zenity-Wrapped Shell Script\n\n<b>Find all streams embed in your multimedia file!</b>\t\n\n " --ellipsize
file=$(zenity --file-selection)
zenity --info --text="Please do not double click. Bugs in Zenity\n\n\n\n\n" --ellipsize
if [[ $file != '' ]] ;then
populate_info "$file";
number_of_streams=$(cat map_story | wc -l);

cat stderr | grep -i stream | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9}' | grep -n . >aggregate_streams
chosen=$(cat aggregate_streams | zenity --list --column="Stream info" --height=300);
echo _____________$chosen;
chosen_no=$(cat aggregate_streams | grep -n "$chosen"  | awk -F ":" '{print $1}');

chosen_again=$(cat map_story | head -n$chosen_no | tail -n1 | cut -c4 --complement );
echo $chosen_again | xclip -i -selection clipboard

zenity --info --text="$chosen_again copied to clipboard."

fi;
#i=1; while [[ $i -le $number_of_streams ]]; do


#done
