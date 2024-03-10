function dataset_disparity_carousel(datasetPath, dataset, frameStep)
    
    leftCamFilenames = dataset.body{1, 1}.sensor{1, 1}.data.filenames;
    rightCamFilenames = dataset.body{1, 1}.sensor{1, 2}.data.filenames;
    pathLeft = strcat(dataset.body{1, 1}.name, '/', dataset.body{1, 1}.sensor{1, 1}.name, '/data');
    pathRight = strcat(dataset.body{1, 1}.name, '/', dataset.body{1, 1}.sensor{1, 2}.name, '/data');

    figure;

    l = min(length(leftCamFilenames), length(rightCamFilenames));
    for i = 1:frameStep:l
        leftFilename = leftCamFilenames{1, i};
        rightFilename = rightCamFilenames{1, i};
        fprintf('%s, %s\n', leftFilename, rightFilename);
        assert(strcmp(leftFilename, rightFilename), 'Wrong left-right frame association');

        leftFilename = strcat(datasetPath, '/', pathLeft, '/', leftCamFilenames{1, i});
        rightFilename = strcat(datasetPath, '/', pathRight, '/', rightCamFilenames{1, i});
        leftFrame = im2gray(imread(leftFilename));
        rightFrame = im2gray(imread(rightFilename));
        
        dr = [0 64];
        d = disparitySGM(leftFrame, rightFrame, DisparityRange=dr, UniquenessThreshold=20);
        
        imshow(d, dr);
        title(strcat("Disparity Heatmap: ", leftFilename));
        colormap jet;
        colorbar;
        waitforbuttonpress;
    end
    close
end