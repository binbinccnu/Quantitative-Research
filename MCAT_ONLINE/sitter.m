function [x1,x2,x3,x4,y1,y2,y3,y4] = sitter(a1,a2,b)

% % choose candidate points
% z_plus_x_plus = ( 1.22-b - 2*a1)/a2;
% z_plus_x_minu = ( 1.22-b + 2*a1)/a2;
% 
% z_plus_y_plus = ( 1.22-b - 2*a2)/a1;
% z_plus_y_minu = ( 1.22-b + 2*a2)/a1;
%     
% z_minu_x_plus = (-1.22-b - 2*a1)/a2;
% z_minu_x_minu = (-1.22-b + 2*a1)/a2;
% 
% z_minu_y_plus = (-1.22-b - 2*a2)/a1;
% z_minu_y_minu = (-1.22-b + 2*a2)/a1;
% 
% xs = [z_plus_x_plus; z_plus_x_minu; z_minu_x_plus; z_minu_x_minu];
% ys = [z_plus_y_plus; z_plus_y_minu; z_minu_y_plus; z_minu_y_minu];
% 
% cor = [2 -2 2 -2];
% 
% index_x = abs(xs) <= 2;
% index_y = abs(ys) <= 2;
% 
% thetas = [[cor(index_x == 1)'  xs(index_x == 1)]; [ ys(index_y == 1) cor(index_y == 1)']];
% 
% x1 = thetas(1,1); y1 = thetas(1,2);
% x2 = thetas(2,1); y2 = thetas(2,2);
% x3 = thetas(3,1); y3 = thetas(3,2);
% x4 = thetas(4,1); y4 = thetas(4,2);

%%
x1 = ( 1.22 + 2*a2 - b) / (a1 + a2);  y1 = x1 - 2;
x2 = (-1.22 + 2*a2 - b) / (a1 + a2);  y2 = x2 - 2;

x3 = ( 1.22 - 2*a2 - b) / (a1 + a2);  y3 = x3 + 2;
x4 = (-1.22 - 2*a2 - b) / (a1 + a2);  y4 = x4 + 2;
