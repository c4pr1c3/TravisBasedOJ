#!/usr/bin/env bash
set -e

LANG=en_US.UTF-8

COL_SIZE=10
NAME_INDEX=8
AGE_INDEX=5
POSTION_INDEX=4

MAX_AGE=0
MIN_AGE=1024
LONGEST_NAME_LEN=0
SHORTEST_NAME_LEN=1024

max_age_arr=()
min_age_arr=()
longest_name_arr=()
shortest_name_arr=()
below20_arr=()
between20and30_arr=()
above30_arr=()
skipped_arr=()
invalid_arr=()
declare -A -g positions_dict

line_num=0

process_log() {
  input_log="$1"
  while IFS= read -r line || [ -n "$line" ];do
    #echo "$line"
    # Group	Country	Rank	Jersey	Position	Age	Selections	Club	Player	Captain		
    # A	Cameroon	56	13	Forward	25	26	Mainz 5  	Maxim Choupo-Moting	0		
    IFS=$'\t' read -r -a line_arr <<< "$line"
    name="${line_arr[$NAME_INDEX]}"
    age=${line_arr[$AGE_INDEX]}

    if ! [[ $age =~ ^[0-9]+$ ]];then
      skipped_arr+=("$line")
      continue
    fi
    line_num=$((line_num+1))
    position="${line_arr[$POSTION_INDEX]}"
    if [[ -z ${positions_dict[$position]} ]];then
      positions_dict[$position]=1
    else
      temp=${positions_dict[$position]}
      positions_dict[$position]=$((temp+1))
    fi
    if [[ ${#line_arr[@]} -ne $COL_SIZE ]];then
      # 目前已知的一行脏数据是多了一个 TAB ，不影响统计任务 
      invalid_arr+=("$line")
    fi
    # 将年龄最大的选手选出来，添加到数组 $max_age_arr
    if [[ $age -ge $MAX_AGE ]];then
      MAX_AGE=$age
      while : ;do
        max_age_arr_size=${#max_age_arr[@]}
        last_max_age_index=$((max_age_arr_size - 1))
        if [[ $last_max_age_index -lt 0 ]];then
          break
        fi
        last_max_age_item="${max_age_arr[$last_max_age_index]}"
        last_max_age=$(echo -n -e "$last_max_age_item" | awk -F '\t' '{ print $1 }' | tr -d ' ')
        if [[ $last_max_age -ge $MAX_AGE ]];then
          break
        else
          unset "max_age_arr[$last_max_age_index]"
        fi
      done
      if [[ $last_max_age_index -lt 0 || $last_max_age -eq $MAX_AGE ]];then
        max_age_arr+=("$age\t$name")
      fi
    fi
    # 将年龄最小的选手选出来，添加到数组 $min_age_arr
    if [[ $age -le $MIN_AGE ]];then
      MIN_AGE=$age
      while : ;do
        min_age_arr_size=${#min_age_arr[@]}
        last_min_age_index=$((min_age_arr_size - 1))
        if [[ $last_min_age_index -lt 0 ]];then
          break
        fi
        last_min_age_item="${min_age_arr[$last_min_age_index]}"
        last_min_age=$(echo -n -e "$last_min_age_item" | awk -F '\t' '{ print $1 }' | tr -d ' ')
        if [[ $last_min_age -le $MIN_AGE ]];then
          break
        else
          unset "min_age_arr[$last_min_age_index]"
        fi
      done
      if [[ $last_min_age_index -lt 0 || $last_min_age -eq $MIN_AGE ]];then
          min_age_arr+=("$age\t$name")
      fi
    fi

    name_len=${#name}
    if [[ ${name_len} -ge $LONGEST_NAME_LEN ]];then
      LONGEST_NAME_LEN=${name_len}
      while : ;do
        longest_name_arr_size=${#longest_name_arr[@]}
        last_longest_name_index=$((longest_name_arr_size - 1))
        if [[ $last_longest_name_index -lt 0 ]];then
          break
        fi
        last_longest_name_item="${longest_name_arr[$last_longest_name_index]}"
        last_longest_name_len=$(echo -n -e "$last_longest_name_item" | awk -F '\t' '{ print $1 }' | tr -d ' ')
        if [[ $last_longest_name_len -ge $LONGEST_NAME_LEN ]];then
          break
        else
          unset "longest_name_arr[$last_longest_name_index]"
        fi
      done
      if [[ $last_longest_name_index -lt 0 || $last_longest_name_len -eq $LONGEST_NAME_LEN ]];then
        longest_name_arr+=("${name_len}\t$name")
      fi
    fi
    if [[ ${name_len} -le $SHORTEST_NAME_LEN ]];then
      SHORTEST_NAME_LEN=${name_len}
      while : ;do
        shortest_name_arr_size=${#shortest_name_arr[@]}
        last_shortest_name_index=$((shortest_name_arr_size - 1))
        if [[ $last_shortest_name_index -lt 0 ]];then
          break
        fi
        last_shortest_name_item="${shortest_name_arr[$last_shortest_name_index]}"
        last_shortest_name_len=$(echo -n -e "$last_shortest_name_item" | awk -F '\t' '{ print $1 }' | tr -d ' ')
        if [[ $last_shortest_name_len -le $SHORTEST_NAME_LEN ]];then
          break
        else
          unset "shortest_name_arr[$last_shortest_name_index]"
        fi
      done
      if [[ $last_shortest_name_index -lt 0 || $last_shortest_name_len -eq $SHORTEST_NAME_LEN ]];then
        shortest_name_arr+=("${name_len}\t$name")
      fi
    fi

    if [[ $age -lt 20 ]];then
      below20_arr+=("$age\t$name")
    elif [[ $age -ge 20 && $age -le 30 ]];then
      between20and30_arr+=("$age\t$name")
    elif [[ $age -gt 30 ]];then
      above30_arr+=("$age\t$name")
    else
      skipped_arr+=("$line")
    fi
  done < "$input_log"
}

get_age_stats() {
  below20=${#below20_arr[@]}
  between20and30=${#between20and30_arr[@]}
  above30=${#above30_arr[@]}
  below20_ratio=$(echo "scale=2; 100*${below20}/$line_num" | bc | sed 's/^\./0./')
  between20and30_ratio=$(echo "scale=2; 100*${between20and30}/$line_num" | bc | sed 's/^\./0./')
  above30_ratio=$(echo "scale=2; 100*${above30}/$line_num" | bc | sed 's/^\./0./')
  echo "-------- Age Statistics --------"
  echo -e "(0, 20) \t$below20\t${below20_ratio}%"
  echo -e "[20, 30]\t$between20and30\t${between20and30_ratio}%"
  echo -e "(30, +∞)\t$above30\t${above30_ratio}%"
}

get_max_age() {
  echo "-------- Oldest Names --------"
  for item in "${max_age_arr[@]}";do
    echo -e "$item"
  done
}

get_min_age() {
  echo "-------- Youngest Names --------"
  for item in "${min_age_arr[@]}";do
    echo -e "$item"
  done
}

get_longest_names() {
  echo "-------- Longest Names --------"
  for item in "${longest_name_arr[@]}";do
    echo -e "$item"
  done
}

get_shortest_names() {
  echo "-------- Shortest Names --------"
  for item in "${shortest_name_arr[@]}";do
    echo -e "$item"
  done
}

print_skipped_lines() {
  echo "-------- Skipped Lines --------"
  for line in "${skipped_arr[@]}";do
    echo -e "$line"
  done
}

print_invalid_lines() {
  echo "-------- Invalid Lines --------"
  for line in "${invalid_arr[@]}";do
    echo -e "$line"
  done
}

get_positions_stats() {
  echo "-------- Positions Statistics --------"
  for position in "${!positions_dict[@]}";do
    count=${positions_dict[$position]}
    ratio=$(echo "scale=2; 100*${count}/$line_num" | bc | sed 's/^\./0./')
    echo -e "$position\t$count\t${ratio}%"
  done
}
