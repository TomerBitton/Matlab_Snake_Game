function varargout = snake_g(varargin)
%Initialization code (defult)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @snake_g_OpeningFcn, ...
                   'gui_OutputFcn',  @snake_g_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code


% --- Executes just before snake_g is made visible.
function snake_g_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to snake_g (see VARARGIN)

% Choose default command line output for snake_g
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes snake_g wait for user response (see UIRESUME)
% uiwait(handles.figure1);

axes(handles.axes1);
axis('off');
global highestScore;
global score_keeper;
if score_keeper >= 1 
    highestScore = score_keeper;
else
    highestScore = 0;
end
set(handles.highest_score, 'String', num2str(highestScore));

% --- Outputs from this function are returned to the command line.
function varargout = snake_g_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
start_game_Callback(hObject, eventdata, handles);

% Right - 1
% Up - 2
% Left - 3
% Down - 4

% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up 
% eventdata  reserved 
% handles structure with handles and user data 
global direction;
if ~(direction==4)
    direction=2;
end

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right 
% eventdata  reserved 
% handles    structure with handles and user data 
global direction ;
if ~(direction==3)
    direction=1; 
end

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down 
% eventdata  reserved 
% handles    structure with handles and user data 
global direction ;
if ~(direction==2)
    direction=4;  
end

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left 
% eventdata  reserved 
% handles    structure with handles and user data
global direction;
if ~(direction==1)
    direction=3;   
end


% --- Executes on button press in start_game.
function start_game_Callback(hObject, eventdata, handles)

% create global variables
global mata matb matc;
global direction;direction=3; % Default movement is Left
global points, points=0;
global highestScore;
global score_keeper;

% updated GUI element with the value of highestScore,points
set(handles.highest_score, 'String', num2str(highestScore));
set(handles.score, 'String', points);

% snake coordinates
locx=[50 50 50 50 50 50 50 50 50];
locy=[60 61 62 63 64 65 66 67 68];

% creating game board with black background
mata=zeros(100,100);
matb=zeros(100,100);
matc=zeros(100,100);

% update the graphical representation of the snake
update_snake(locx,locy);

% Set the left and right sides of the square with yellow boundary
mata(:, [1, end]) = 255;
matb(:, [1, end]) = 255;
matc(:, [1, end]) = 0;

% Set the top and bottom sides of the square with yellow boundary
mata([1, end], :) = 255;
matb([1, end], :) = 255;
matc([1, end], :) = 0;

% Save the figure handle in 'UserData'
set(handles.figure1, 'UserData', hObject);

% Store the current figure handle
hFigure = gcf;

while(1)
        % generates a random point ("apple")
        point_x = randi([2, size(mata, 1) - 1], 1);
        point_y = randi([2, size(mata, 2) - 1], 1);
        % check if the random point is on our boundaries
        if sum(locx==point_x & locy==point_y)==0
        break;
        end
end
% make the random point visible with white color
mata(point_x,point_y)=255;
matb(point_x,point_y)=255;
matc(point_x,point_y)=255;
% displays the composite image, combines the three matrices into a single 3D array 
imshow(uint8(cat(3,mata,matb,matc)));

while(1)
    imshow(uint8(cat(3,mata,matb,matc)));
    % control the snake speed.
    pause(0.04);
        len=length(locx);
        % clears the previous position of the snake from the image
        for i=1:len
            mata(locx(i),locy(i))=0;
            matb(locx(i),locy(i))=0;
            matc(locx(i),locy(i))=0;
        end
        % check if the snake ate the apple
        if sum((locx(1)==point_x) & (locy(1)==point_y))==1
        % shifts all the elements in the arrays one position to the right.
            locx(2:len+1)=locx(1:len);
            locy(2:len+1)=locy(1:len);
            while(1) 
                % generates a new random point ("apple")
                point_x = randi([2, size(mata, 1) - 1], 1);
                point_y = randi([2, size(mata, 2) - 1], 1);
                % check if the random point is on our boundaries
                if sum(locx==point_x & locy==point_y)==0
                    break;
                end
            end
            % make the random point visible with white color
            mata(point_x,point_y)=255;
            matb(point_x,point_y)=255;
            matc(point_x,point_y)=255;
            points=points+1;
            % Checks if the number of points is greater than the highest number of points
            if points > highestScore
            highestScore = points;
            score_keeper = points;
            % GUI element displaying the highest score
            set(handles.highest_score, 'String', num2str(highestScore));
            end
            set(handles.score,'String',num2str(points));
        else
            % shifts all the elements in the arrays one position to the left.
            locx(2:len)=locx(1:len-1);
            locy(2:len)=locy(1:len-1);
        end
         if direction==1
             % checks if the snake has hit the boundary of the game board
             if locy(1)==100
                 % create yellow wall
                    mata(:,:) = 255;
                    matb(:,:) = 255;
                    matc(:,:) = 0;
        imshow(uint8(cat(3,mata,matb,matc)));
         msgbox('Game Over');
        break;
             % if not continue moving right
             else
                 locy(1)=locy(1)+1;
             end
         elseif direction==2
             if locx(1)==1
                     mata(:,:) = 255;
                     matb(:,:) = 255;
                     matc(:,:) = 0;
        imshow(uint8(cat(3,mata,matb,matc)));
        msgbox('Game Over');
        break;
             else 
                 locx(1)=locx(1)-1;
             end
         elseif direction==3
             if locy(1)==1
                    mata(:,:) = 255;
                    matb(:,:) = 255;
                    matc(:,:) = 0;
        imshow(uint8(cat(3,mata,matb,matc)));
        msgbox('Game Over');
        break;
             else
                 locy(1)=locy(1)-1;
             end
         elseif direction==4
             if locx(1)==100
                    mata(:,:) = 255;
                    matb(:,:) = 255;
                    matc(:,:) = 0;
        imshow(uint8(cat(3,mata,matb,matc)));
        msgbox('Game Over');
        break;
             else
                 locx(1)=locx(1)+1;
             end
         end
         % checks if the snake's head collides with any part of its body
         if sum((locx(2:end)==locx(1)) & (locy(2:end)==locy(1))) >=1
             mata(:,:)=255;
             matb(:,:)=255;
             matc(:,:)=0;
             imshow(uint8(cat(3,mata,matb,matc)));
             msgbox('Game Over');
             break;
         end
         update_snake(locx,locy);
  % Check if the figure is still valid
    try
        get(hFigure, 'Name');
    catch
        % If the figure is closed, stop the loop
        break;
    end
end
% When the loop is stopped, close the figure
if ishandle(hFigure)
    close(hFigure);
end


% --- Executes on button press in end_game.
function end_game_Callback(hObject, eventdata, handles)
% hObject    handle to end_game (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global highestScore;
global score_keeper;
highestScore=0;
score_keeper=0;
close; 


function update_snake(locx,locy)
global mata matb matc
    % create the red color for snake head
    mata(locx(1),locy(1))=255;
    matb(locx(1),locy(1))=0;
    matc(locx(1),locy(1))=0;

    for i=2:length(locx)
        % create the green color for snake body
        mata(locx(i),locy(i))=0;
        matb(locx(i),locy(i))=255;
        matc(locy(i),locy(i))=0;
    end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data 
global direction ;
%  determine which arrow key was pressed 
switch(eventdata.Key)
% update the direction variable accordingly to control the movement direction in a game.
    case 'uparrow'
        if ~(direction==4)
            direction=2;
        end
    case 'downarrow'
        if ~(direction==2)
            direction=4;
        end
    case 'rightarrow'
        if ~(direction==3)
            direction=1;  
        end
    case 'leftarrow'
        if ~(direction==1)
            direction=3;
        end
    case 'return'
    
    otherwise
        direction=direction; 
end
