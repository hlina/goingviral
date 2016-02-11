from flask import Flask, render_template, request, session, redirect, url_for
import matlab.engine

app = Flask(__name__)

results = []


@app.route("/")
def home():
  return render_template('goingViral.html')

@app.route("/all_data")
def all():
  return render_template('graphs.html')

@app.route("/city_data")
def city():
  return render_template('graph.html')

@app.route("/heat_map")
def map():
  return render_template('graph2.html')

def perform_optimization(budget, year):
  eng = matlab.engine.start_matlab()
  answer = eng.test_robust_allocation(float(budget), nargout = 3)
  return answer

@app.route("/optimization", methods=['GET', 'POST'])
def optimization():
  if request.method == 'POST':
    results.append(perform_optimization(request.form['budget'], request.form['year']))
    return redirect(url_for('show_results', result_id=len(results)-1))
  else:
    return render_template('graph4.html')

@app.route("/optimize/<int:result_id>")
def show_results(result_id):
  print results
  return render_template('optimize.html', data=results[result_id])

app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'

if __name__ == '__main__':
  app.run(debug=True)
