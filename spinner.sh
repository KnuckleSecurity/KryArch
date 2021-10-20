
function spin()
{
    while [ true ]
    do
        for i in "$@"
        do
            echo -ne "\e[7m\r$i \e[27m"
            sleep 0.2
        done
    done
}

spinner1=( ~Running... ~rUnning... ~ruNning... ~runNing... ~runnIng... ~runniNg... ~runninG... )

spin ${spinner1[@]} &
sleep 3
