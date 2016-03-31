import matlab.engine

eng = matlab.engine.start_matlab()
eng.cvx_setup(nargout=0)
answer = eng.test_model2(50000.0, 1, 'our_model_west.mat', 2, nargout = 3)
print "answer"
print answer
