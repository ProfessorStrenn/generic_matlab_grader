
function tests = generic_grader
%  NOTE:  Change the name of this function, and change the corresponding parameter in 
%  the runtests() call below.
%
%  Main function to generate tests and, if necessary, call this function as a unit test.

%  If the dbstack size is 1, the user ran this function directly.  So
%  re-call this function as a unit test.
if length(dbstack) == 1   
    runtests('generic_grader.m');
else
    tests = functiontests(localfunctions);
end

end


function setupOnce(testCase)
%  Initialize the grade script.

clr;

global assnBaseScore;
global assnMaxScore;
global assnExtraCredit;

assnBaseScore = 0;
assnMaxScore = 100;
assnExtraCredit = 0;

fprintf('================================================================================\n\n');

end


function teardownOnce(testCase)
%  Display the grade report

global assnBaseScore;
global assnMaxScore;
global assnExtraCredit;

fprintf('\n\n\n\n');
fprintf('================================================================================\n');
fprintf('\n    Note:  These scores do not include any penalties (e.g. late submission).\n\n');
fprintf('  SCORE         :  %2d      points\n', assnBaseScore);
fprintf('  EXTRA CREDIT  :  %2d      points\n', assnExtraCredit);
fprintf('  TOTAL         :  %2d / %2d points\n', assnBaseScore + assnExtraCredit, assnMaxScore);
fprintf('\n');
fprintf('================================================================================\n\n');

end


function testOne(testCase)
%  Verifies that the code meets the functional requirements specified in the assignment.
%  Change this test name to describe the test that is implement in this function.
%  The function name must start with the word 'test'.
%  See https://www.mathworks.com/help/matlab/matlab-unit-test-framework.html?s_tid=srchtitle for 
%  more details on unit testing.
%  Multiple tests are supported (and encouraged!).  Each must have a unique name that starts
%  with 'test'.

global assnBaseScore;
global assnExtraCredit;

%  Generic Grading Procedure:
%
%  1)  Prepare any data that is required for this test.
%  2)  Call the student's function or script.
%  3)  Use fprintf() and related to display information for the student.
%  4)  Make calls to test framework functions like assertEqual() and assertNotEmpty(), as in:
%        assertEqual(testCase, sqrt(4), 2);
%  5)  For assertions that do not fail, update the scoring variables, as in:
%        assnBaseScore = assnBaseScore + 2;
%      or
%        assnExtraCredit = assnExtraCredit + 1;

end




function setup(testCase)
% Clear vars and handles (but not the overall scores)

clre;

end



%% Utility functions

function clr()
% Clears figures, variables, classes, and the command line

warning 'off';
clc;
clear classes;
set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));
clear classes;
warning 'on';
end


function clre()
% Clears figures and vars (except the global grade variables)
warning 'off';
set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));
clearvars -except assnBaseScore assnMaxScore assnExtraCredit;
warning 'on';
end


function name = currentFunctionName()
% Gets the name of the currently executing function

n = dbstack;
name = n(2).name;
end