function centroid = calculate_centroid(stl_model)
    points = stl_model.Points;
    centroid = mean(points);
end
