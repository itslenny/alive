class TestWorker < Worker
  worker :queue => :exigent

  def perform(test_id)
    test = Test.find(test_id)

    test.update(:at => test.at+test.interval)

    run = TestRun.create(:user => test.user, :test => test)
    TestRunWorker.perform_async(run.id)
  end
end
