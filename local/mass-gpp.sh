for appid in `grep -Eoh \"[0-9]*\" data/game_names | cut -d "\"" -f 2` 
    do
    perl analysis/single_game_playtime.pl $appid
    echo $appid "done"
    done

echo "All gpps done"