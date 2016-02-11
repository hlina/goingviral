import matlab.engine

eng = matlab.engine.start_matlab()
# eng.addpath(eng.genpath('/home/muniza/Downloads/ESE451'),nargout=0)
# eng.cvx_setup(nargout=0)
answer = eng.test_robust_allocation(5000.0, nargout = 3)
print "answer"
print answer