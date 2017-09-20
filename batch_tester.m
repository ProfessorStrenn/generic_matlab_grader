function results = batch_tester(targetFilenameNoExt, testerFullPath)

startDirectory = cd;

try 
submissionsDirPath = pwd;
[testerDir, testerFilenameNoExt, testerExt] = fileparts(testerFullPath);
cd(submissionsDirPath);

submittedFiles = dir('*.m');
submittedFilenames = {submittedFiles.name};
results = cell(length(submittedFilenames), 1);

ndx = 1;
for submittedFilenameCell = submittedFilenames
    cd(submissionsDirPath);
    submittedFilename = submittedFilenameCell{1};
    tokens = regexp(submittedFilename, ['(.*)_' targetFilenameNoExt '(.*)'], 'tokens');
    dirName = tokens{1}{1};
    targetMFilename = [targetFilenameNoExt tokens{1}{2}];
    % replace endings like -1.m or -2.m with just .m
    targetMFilename = regexprep(targetMFilename, '-\d.*\.m', '.m');
    if exist(dirName, 'dir')
        rmdir(dirName, 's');
    end
    mkdir(dirName);
    copyfile(submittedFilename, [dirName filesep targetMFilename]);
    copyfile(testerFullPath, [dirName filesep testerFilenameNoExt '.m']);
    cd(dirName);
    diary('score.txt');
    runtests([testerFilenameNoExt '.m']);
    diary off;
    scoreText = fileread('score.txt');
    
    score = regexp(scoreText, 'TOTAL.*:\s*(\d+).*points', 'tokens');
    
    diag = '';
    if ~isempty(strfind(dirName, '_late_'))
        diag = '* LATE *    ';
    end
    
    t = regexp(scoreText, 'Test Diagnostic:(.*)Framework Diagnostic:', 'tokens');
    if ~isempty(t)
        diag = [diag strtrim(strip(strtrim(regexprep(t{1}{1}, '[\r\n\",]', '')), '-'))];
    end
    
    e = regexp(scoreText, 'Error Details:(.*)===========', 'tokens');
    if ~isempty(e)
        diag = [diag strtrim(strip(strtrim(regexprep(e{1}{1}, '[\r\n\",]', '')), '-'))];
    end
    
    results{ndx}  = {dirName, str2double(score{1}{1}), diag};
    ndx = ndx + 1;
end

cd(startDirectory);

% Write out the scores to a file
fileID = fopen([targetFilenameNoExt '_scores.csv'],'w');
formatSpec = '%s, %f, \"%s\"\n';
[nrows,ncols] = size(results);
for row = 1:nrows
    fprintf(fileID,formatSpec,results{row}{1}, results{row}{2}, results{row}{3});
end
fclose(fileID);

catch ME
    cd(startDirectory);

    rethrow(ME)
end
