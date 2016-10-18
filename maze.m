function maze(m,n)

% Initialize
maze = ones(m,n)*15;
stack = zeros(m*n + 1, 1);

% Create
i = floor(rand*m + 1);
j = floor(rand*n + 1);

do
  if (mod(floor(maze(i,j)/2^4), 2) == 0)
    maze(i, j) += 16;
  end
  vec = getUnvisited(maze, i, j);
  if ( vec(1) ~= 0 )
    index = floor(rand*vec(1) + 2);
    k = mod(vec(index),m) + 1;
    l = floor(vec(index)/m) + 1;
    maze = removeWall(maze, i, j, k, l);
    stack = push(stack, (j-1)*m + (i-1));
    i = k;
    j = l;
  else
    [val,stack] = pop(stack);
    i = mod(stack(stack(1) + 1), m) + 1;
    j = floor(stack(stack(1) + 1)/m) + 1;
  end
until stack(1) == 0

% Plot
drawMaze(maze, 10);

end % mazesa


function vec = getUnvisited(maze, i, j)
  m = size(maze, 1);
  n = size(maze, 2);
  vec = zeros(5, 1);
  for k=max(i-1, 1):min(i+1, m)
    if (mod(floor(maze(k,j)/2^4), 2) == 0)
      vec(1) += 1;
     vec(vec(1)+1) = (j-1)*m + (k-1);
   end
  end
  for l=max(j-1, 1):min(j+1, n)
    if (mod(floor(maze(i,l)/2^4) ,2) == 0 )
     vec(1) += 1;
     vec(vec(1)+1) = (l-1)*m + (i-1);
    end
  end % getUnvisited
end


function mz = removeWall(maze, i, j, k, l)
  if (k < i) && (l == j)
    maze(i, j) -= 4;
    maze(k, l) -= 1;
  elseif (k > i) && (l == j)
    maze(i,j) -= 1;
    maze(k,l) -= 4;
  elseif (k == i) && (l < j)
    maze(i,j) -= 8;
    maze(k,l) -= 2;
  elseif (k == i) && (l > j)
    maze(i, j) -= 2;
    maze(k, l) -= 8;
  endif
  mz = maze;
end % removeWall


function [val, s] = pop(stack)
  val = stack(stack(1) + 1);
  stack(1) -= 1;
  s = stack;
end % pop


function s = push(stack, val) 
  stack(1) += 1;
  stack(stack(1) + 1) = val;
  s = stack;
end % push


function drawMaze(maze, cellSize)
  path = './';
  m = size(maze, 1);
  n = size(maze, 2);
  w = m*cellSize;
  h = n*cellSize;
  fout = fopen( strcat(path , 'maze.svg' ) ,'w');
  fprintf(fout ,'%s \n', '<?xml version="1.0" standalone="no"?>');
  fprintf(fout ,'%s \n', '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"');
  fprintf(fout ,'%s \n\n', '"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">');
  fprintf(fout ,'%s \n', '<svg width="100%" height="100%" version="1.1"');
  fprintf(fout ,'%s \n\n', 'xmlns="http://www.w3.org/2000/svg">');
  fprintf(fout ,'<polygon points="1,1 1,%d %d,%d %d,1" \n', h, w, h, w);
  fprintf(fout ,'%s \n', 'style="fill:#ffffff;');
  fprintf(fout ,'%s \n\n', 'stroke:black;stroke-width:2"/>');
  fprintf(fout ,'%s \n', '<path d="');
  xc = m/w;
  yc = n/h;
  for i = 1 : m
    for j = 1 : n
      if ( mod(floor(maze(i,j)/2^0),2) == 1 )
        fprintf(fout ,'M%8.2f %8.2f L%8.2f %8.2f \n', i/xc, (j-1)/yc, i/xc, j/yc );
      end  
      if ( mod(floor(maze(i,j)/2^1),2) == 1 )
        fprintf(fout ,'M%8.2f %8.2f L%8.2f %8.2f \n', (i-1)/xc, j/yc, i/xc, j/yc );
      end  
      if ( mod(floor(maze(i,j)/2^2),2) == 1 )
        fprintf(fout ,'M%8.2f %8.2f L%8.2f %8.2f \n', (i-1)/xc, (j-1)/yc, (i-1)/xc, j/yc );
      end  
      if ( mod(floor(maze(i,j)/2^3),2) == 1 )
        fprintf(fout ,'M%8.2f %8.2f L%8.2f %8.2f \n', (i-1)/xc, (j-1)/yc, i/xc, (j-1)/yc );
      end  
    end
  end
  fprintf(fout ,'%s \n', '"');
  fprintf(fout ,'%s \n', 'style="stroke:black;stroke-width:1"/>');
  fprintf(fout ,'%s \n', '</svg>');
  fclose(fout);
end %drawMaze
