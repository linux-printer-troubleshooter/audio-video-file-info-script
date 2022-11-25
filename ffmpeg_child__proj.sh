

populate_info () {
ffmpeg -i "$1" 2>stderr
cat stderr | grep -i stream | awk '{print $2}' | awk -F "(" '{print $1}' | awk -F "#" '{print $2}' >map_story
cat stderr | grep -i stream | awk '{print $3}' | awk -F ":" '{print $1}' >stream_story
}
file="$1"
echo $file;
if [[ $file != '' ]] ;then
populate_info "$file";
number_of_streams=$(cat map_story | wc -l);

cat stderr | grep -i stream | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13" "$15}' | grep -n . >aggregate_streams
fi;
#i=1; while [[ $i -le $number_of_streams ]]; do


#done
audio_stream_count=0;video_stream_count=0;

number_of_line=$(cat aggregate_streams | wc -l);
i_counter=1;
while [ $i_counter -le $number_of_line ];
do
index=$(( i_counter-1 ));
if [[ "$(cat aggregate_streams | head -n$i_counter | tail -n1 |  awk '{print $3}')" =~ Audio ]];then  audio_stream_count=$(( audio_stream_count+1 ));orig_counter[$index]="Audio";
tmp1="$(cat aggregate_streams | grep -o -E [0-9]\+" Hz" | sed 's/ /-/g' | grep [0-9])";
bitrate[$index]="$tmp1";
fi;
if [[ "$(cat aggregate_streams | head -n$i_counter | tail -n1 |  awk '{print $3}')" =~ Video ]];then video_stream_count=$(( video_stream_count+1 )) ; orig_counter[$index]="Video"
resolution="$(cat aggregate_streams | grep -o -E [0-9]\+[x][0-9]\+)";
echo $resolution | sed 's/[ . ]/&\n/g' >resolutions.txt;

counter=1;counters=$(cat resolutions.txt | wc -l);
while [[ $counter -le $counters ]];
do resolution=$(cat resolutions.txt | head -n$counter | tail -n1);
first_part=$(echo $resolution | awk -F "x" '{print $1}');
second_part=$(echo $resolution | awk -F "x" '{print $2}');
if [[ $first_part == '0' ]] || [[ $second_part == '0' ]];
then
echo -ne "";
else
real_resolution=$resolution;
echo Resolution:$resolution;
fi;
counter=$(( counter+1 ));
done;
fi;
i_counter=$(( i_counter+1 ));

done;
echo Audio:$audio_stream_count;echo video:$video_stream_count
for i in ${bitrate[@]};do echo  "Bitrate:"$i;done;

#if [[ $audio_stream_count -ne 0 ]];then
#for i in ${bitrate[@]};do echo -ne "Audio is "$i respectively;done; echo and video"'s"; else echo Audio Stream Not found"!";fi;
#for i in ${real_resolution[@]};do echo " Resolution is "$i respectively;done;



