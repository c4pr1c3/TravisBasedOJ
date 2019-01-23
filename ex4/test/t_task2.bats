#!/usr/bin/env bats

source task2.sh

[[ $(command -v process_log) ]] && {
    process_log "$INPUT_LOG"
}

@test "shellcheck task2.sh" {
    run shellcheck task2.sh
    if [[ $status -ne 0 ]];then
        skip "$output"
    fi
}

@test "check print_skipped_lines" {
    [[ $(command -v print_skipped_lines ) ]] || {
        skip "ignore print_skipped_lines"
    }
    run print_skipped_lines
    [ $status -eq 0 ]
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_SKIPPED_LINES_1" ]]
    [[ "$output" =~ "$EX4_2_EXPECTED_SKIPPED_LINES_2" ]]
    echo "$output" > /tmp/output.log
}

@test "check print_invalid_lines" {
    [[ $(command -v print_invalid_lines) ]] || {
        skip "ignore print_invalid_lines"
    }
    run print_invalid_lines
    [ $status -eq 0 ]
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_INVALID_LINES_1" ]]
    [[ "$output" =~ "$EX4_2_EXPECTED_INVALID_LINES_2" ]]
    echo "$output" >> /tmp/output.log
}

@test "check get_age_stats" {
    run get_age_stats 
    [ $status -eq 0 ]
    echo "$output" >> /tmp/output.log
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_AGE_1" ]]
    IFS='' read -r -a pattern_arr <<< "$EX4_2_EXPECTED_AGE_2"
    for pattern in "${pattern_arr[@]}";do
        [[ "$output" =~ "$pattern" ]]
    done
}

@test "check get_positions_stats" {
    run get_positions_stats
    [ $status -eq 0 ]
    echo "$output" >> /tmp/output.log
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_POS_1" ]]
    IFS='' read -r -a pattern_arr <<< "$EX4_2_EXPECTED_POS_2"
    for pattern in "${pattern_arr[@]}";do
        [[ "$output" =~ "$pattern" ]]
    done
}

@test "check get_max_age" {
    run get_max_age
    [ $status -eq 0 ]
    echo "$output" >> /tmp/output.log
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_OLDEST_1" ]]
    [[ "$output" =~ "$EX4_2_EXPECTED_OLDEST_2" ]]
}

@test "check get_min_age" {
    run get_min_age
    [ $status -eq 0 ]
    echo "$output" >> /tmp/output.log
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_YOUNGEST_1" ]]
    IFS='' read -r -a pattern_arr <<< "$EX4_2_EXPECTED_YOUNGEST_2"
    for pattern in "${pattern_arr[@]}";do
        [[ "$output" =~ "$pattern" ]]
    done
}

@test "check get_longest_names" {
    run get_longest_names
    [ $status -eq 0 ]
    echo "$output" >> /tmp/output.log
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_LONGEST_1" ]]
    IFS='' read -r -a pattern_arr <<< "$EX4_2_EXPECTED_LONGEST_2"
    for pattern in "${pattern_arr[@]}";do
        [[ "$output" =~ "$pattern" ]]
    done
}

@test "check get_shortest_names" {
    run get_shortest_names
    [ $status -eq 0 ]
    echo "$output" >> /tmp/output.log
    [[ "${lines[0]}" =~ "$EX4_2_EXPECTED_SHORTEST_1" ]]
    [[ "$output" =~ "$EX4_2_EXPECTED_SHORTEST_2" ]]
}
