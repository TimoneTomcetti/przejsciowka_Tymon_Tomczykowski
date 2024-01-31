function w_f = get_w_f(r,face_points)
r_1 = face_points(1,:) - r;
r_1 = r_1/norm(r_1);
r_2 = face_points(2,:) - r;
r_2 = r_2/norm(r_2);
r_3 = face_points(3,:) - r;
r_3 = r_3/norm(r_3);



w_f = 2 * atan2((dot(r_1,cross(r_2,r_3))),(1 + dot(r_1,r_2) + dot(r_2,r_3) + dot(r_3,r_1)));
end