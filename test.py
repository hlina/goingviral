import matlab.engine

eng = matlab.engine.start_matlab()
# eng.addpath(eng.genpath('/home/muniza/Downloads/ESE451'),nargout=0)
eng.cvx_setup(nargout=0)
answer = eng.test_robust_allocation(5000.0, 1, 'our_model_NE.mat',nargout = 3)
print "answer"
print answer
print answer[0]