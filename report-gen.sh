#!/usr/bin/env bash
# script to traverse folder and generate markdown report
# pass restored files foler as argument

handle_error() {
  echo "Error on line $1"
  exit 1
}

trap 'handle_error $LINENO' ERR

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <target_directory>"
  exit 1
fi

TARGET_DIR=$(readlink -f $1)

printf "\nTarget Directory is $TARGET_DIR\n\n" 

if [ ! -s report_template.md ]; then
  echo "report_template.md not found, exiting..."
  exit 1
fi

CURR_DATE=$(date +"%Y-%m-%d %T")
echo "Current Time is $CURR_DATE"

sed "s/###DATE###/$CURR_DATE/" report_template.md > report.md.temp
if [ $? -ne 0 ]; then 
  echo "Error inserting date into report"
  exit 1
fi
mv report.md.temp report.md

TREE_VIEW=$(tree $TARGET_DIR -L 2 -F | head -n -2)

cat report.md | (
  while read i; do
    if [ "$i" == "##TREE-VIEW##" ]; then
       echo "$TREE_VIEW" | cat 
    else
       echo $i
    fi
  done
) > report.md.temp

if [ $? -ne 0 ]; then 
  echo "Error adding Tree view to report"
  exit 1
else 
  echo "Added Tree view to report succesfully"
fi

mv report.md.temp report.md

mapfile -t FILES_LIST < <(find "$TARGET_DIR" -type f)

index=0
for file in "${FILES_LIST[@]}"; do
  echo "ADDING file $file"
  STAT_INFO=$(stat "$file")
  CHANGE_TIME=$(echo "$STAT_INFO" | awk '/Change:/ {print $2, $3}')
  HUMAN_READABLE_DATE=$(date -d "$CHANGE_TIME" +"%e %B %Y %H:%M:%S")
  printf "\n## %d. $file\n" $((index + 1)) >> report.md
  printf "> Deleted at $HUMAN_READABLE_DATE\n\n" >> report.md # add delete time
  printf "**sha256 of file**\n\`\`\`sh\n$(sha256sum "$file" | awk '{print $1}')\n\`\`\`\n" >> report.md # add sha256 
  printf "\`\`\`sh\n$(file -b "$file")\n\`\`\`\n" >> report.md # adding output of file in a codeblock
  printf "\`\`\`sh\n$STAT_INFO\n\`\`\`\n" >> report.md # adding output of stat in a codeblock
  index=$((index+1))
done


