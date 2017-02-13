require 'spec_helper'

describe 'influxdb::repo::apt' do

  on_supported_os.each do |os, facts|

    # A little ugly, but we only want to run our tests for RHEL based machines.
    if facts[:operatingsystem] == 'Debian'

      context "on #{os}" do
        let(:facts) { facts }

        describe 'with default params' do
          let(:_operatingsystem) { facts[:operatingsystem].downcase }

          it do
            is_expected.to contain_apt__source('repos.influxdata.com').with({
              :ensure      => 'present',
              :location    => "https://repos.influxdata.com/#{_operatingsystem}",
              :release     => facts[:lsbdistcodename],
              :repos       => 'stable',
              :key         => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
              :key_source  => 'https://repos.influxdata.com/influxdb.key',
              :include_src => false,
            })
          end

          it { is_expected.to contain_class('influxdb::repo::apt') }
          it { is_expected.to compile }
        end
      end
    end

  end

end
