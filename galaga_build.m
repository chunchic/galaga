function galaga_build
global cooldown

    galaga_figure = figure('units','normalized','outerposition',[0 0.05 1 0.95],'numbertitle','off','name','Galaga', 'menubar', 'none','Color','w','KeyPressFcn',@player_control);
    galaga_axes = axes('units','normalized','position',[0.05 0.05 0.8 0.95]);
    galaga_axes.XAxis.Visible = 'off';
    galaga_axes.YAxis.Visible = 'off';
    board_length = 70;
    board_height = 50;
    square_size = 1;
    galaga_axes.YLim = [0 board_height];
    galaga_axes.XLim = [0 board_length];    
    for i = 1:board_length
        for j = 1:board_height
            galaga_board(i,j) = rectangle('Position',[i-1 j-1 square_size square_size],'FaceColor','k','EdgeColor','r','UserData','nothing');
        end
    end
    
    cooldown = 0;
    
    player_coord = [34 35 36 34 35 36 35;3 3 3 4 4 4 5];
    for i = 1:size(player_coord,2)
        galaga_board(player_coord(1,i),player_coord(2,i)).FaceColor = 'c';
        galaga_board(player_coord(1,i),player_coord(2,i)).UserData = 'player';
    end
    enemies_number = 30;
    enemies_length = 10;
    enemies_width = 3;
    empty_line = 2;
    enemy = {};
    for i = 1:enemies_length
        for j = 1:enemies_width
            enemy{end+1} = [3*i+empty_line*(i-1) 3*i+1+empty_line*(i-1) 3*i+2+empty_line*(i-1) 3*i+1+empty_line*(i-1);board_height-3-2*empty_line*(j-1) board_height-3-2*empty_line*(j-1) board_height-3-2*empty_line*(j-1) board_height-4-2*empty_line*(j-1)];
        end
    end
    for k = 1:enemies_number
        for i= 1:size(enemy{1},2)
            galaga_board(enemy{k}(1,i),enemy{k}(2,i)).FaceColor = 'w';
            galaga_board(enemy{k}(1,i),enemy{k}(2,i)).UserData = 'enemy';
        end
    end
    enemy_move();
    
    function player_control(hObject,~)
        current_key = get(hObject,'CurrentKey');
        if strcmp(current_key,'a')
            move(current_key)
        elseif strcmp(current_key,'d')
            move(current_key)
        elseif strcmp(current_key,'space')
            if cooldown == 0
                shoot()
            end
        end
    end

    function move(key)
        for i = 1:size(player_coord,2)
            galaga_board(player_coord(1,i),player_coord(2,i)).FaceColor = 'k';
            galaga_board(player_coord(1,i),player_coord(2,i)).UserData = 'nothing';
        end
        if strcmp(key,'a') && player_coord(1,1) > 3
            player_coord(1,:) = player_coord(1,:) - 1;
        elseif strcmp(key,'d') && player_coord(1,3) < board_length-2
            player_coord(1,:) = player_coord(1,:) + 1;
        end
        for i = 1:size(player_coord,2)
            galaga_board(player_coord(1,i),player_coord(2,i)).FaceColor = 'c';
            galaga_board(player_coord(1,i),player_coord(2,i)).UserData = 'player';
        end
    end

    function shoot()
        projectile = [player_coord(1,7),player_coord(2,7)+1];
        galaga_board(projectile(1),projectile(2)).FaceColor = 'r';
        galaga_board(projectile(1),projectile(2)).UserData = 'projectile';
        cooldown = 1;
        while projectile(2) ~= board_height
            delete_projectile();
            projectile(2) = projectile(2) + 1;
            galaga_board(projectile(1),projectile(2)).FaceColor = 'r';
            galaga_board(projectile(1),projectile(2)).UserData = 'projectile';
            pause(0.05);
            if projectile(2) == board_height
                delete_projectile();
                cooldown = 0;
                return
            elseif strcmp(galaga_board(projectile(1),projectile(2)+1).UserData,'enemy')
                delete_projectile();
                cooldown = 0;
                kill_enemy(projectile(1),projectile(2)+1)
                return 
            end
        end
        cooldown = 0;
    
        function delete_projectile(~,~)
            galaga_board(projectile(1),projectile(2)).FaceColor = 'k';
            galaga_board(projectile(1),projectile(2)).UserData = 'nothing';
        end
    end
    
    function kill_enemy(x,y)
        enemy_killed = 0;
        for k = 1:length(enemy)
            for i = 1:size(enemy{1},2)
                if enemy{k}(1,i) == x && enemy{k}(2,i) == y
                    enemy_killed = k;
                    break
                end              
            end
            if enemy_killed == k
                break
            end
        end
        if enemy_killed ~= 0
            for i = 1:size(enemy{1},2)
                galaga_board(enemy{enemy_killed}(1,i),enemy{enemy_killed}(2,i)).FaceColor = 'k';
                galaga_board(enemy{enemy_killed}(1,i),enemy{enemy_killed}(2,i)).UserData = 'nothing';                
            end
            enemy(enemy_killed) = [];
        end
        enemy_killed = 0;
    end

    function enemy_move(~,~)
        direction = 'right';
        while true
            for k = 1:length(enemy)
                for i = 1:size(enemy{1},2)
                    galaga_board(enemy{k}(1,i),enemy{k}(2,i)).FaceColor = 'k';
                    galaga_board(enemy{k}(1,i),enemy{k}(2,i)).UserData = 'nothing';
                end
            end
            for k = 1:length(enemy)
                if strcmp(direction,'right')
                    enemy{k}(1,:) = enemy{k}(1,:) + 1;                    
                elseif strcmp(direction,'left')
                    enemy{k}(1,:) = enemy{k}(1,:) - 1;
                elseif strcmp(direction,'down_l')
                    enemy{k}(2,:) = enemy{k}(2,:) - 1;
                elseif strcmp(direction,'down_r')
                    enemy{k}(2,:) = enemy{k}(2,:) - 1;
                end
            end
            for k = 1:length(enemy)
                for i = 1:size(enemy{1},2)
                    galaga_board(enemy{k}(1,i),enemy{k}(2,i)).FaceColor = 'w';
                    galaga_board(enemy{k}(1,i),enemy{k}(2,i)).UserData = 'enemy';
                end
            end
            if enemy{end}(1,3) == board_length - 2 && strcmp(direction,'right')
                direction = 'down_l';
            elseif enemy{1}(1,1) == 3 && strcmp(direction,'left')
                direction = 'down_r';
            elseif strcmp(direction,'down_l')
                direction = 'left';
            elseif strcmp(direction,'down_r')
                direction = 'right';
            end
            pause(0.2);
            direction
        end
    end
end