describe SidekiqScheduler::Manager do

  describe '.new' do
    subject { described_class.new(options) }

    let(:options) do
      {
        enabled: enabled,
        dynamic: true,
        dynamic_every: '5s',
        listened_queues_only: true,
        schedule: { 'current' => ScheduleFaker.cron_schedule('queue' => 'default') }
      }
    end

    before do
      SidekiqScheduler::Scheduler.enabled = nil
      SidekiqScheduler::Scheduler.dynamic = nil
      SidekiqScheduler::Scheduler.dynamic_every = nil
      SidekiqScheduler::Scheduler.listened_queues_only = nil
      Sidekiq.schedule = { previous: ScheduleFaker.cron_schedule }
    end

    context 'when enabled option is true' do
      let(:enabled) { true }

      it {
        expect { subject }.to change { SidekiqScheduler::Scheduler.enabled }.to(options[:enabled])
      }

      it {
        expect { subject }.to change { SidekiqScheduler::Scheduler.dynamic }.to(options[:dynamic])
      }

      it {
        expect { subject }.to change { SidekiqScheduler::Scheduler.listened_queues_only }.to(options[:listened_queues_only])
      }

      it {
        expect { subject }.to change { Sidekiq.schedule }.to(options[:schedule])
      }
    end

    context 'when enabled option is false' do
      let(:enabled) { false }

      it {
        expect { subject }.to change { SidekiqScheduler::Scheduler.enabled }.to(options[:enabled])
      }

      it {
        expect { subject }.to change { SidekiqScheduler::Scheduler.dynamic }.to(options[:dynamic])
      }

      it {
        expect { subject }.to change { SidekiqScheduler::Scheduler.listened_queues_only }.to(options[:listened_queues_only])
      }

      it {
        expect { subject }.not_to change { Sidekiq.schedule }
      }
    end
  end
end
