require 'spec_helper'

describe 'influxdb::repo' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default params' do

        let(:defined_repos) do
          {
            'Debian' => {
              'contain'     => 'influxdb::repo::apt',
              'not_contain' => 'influxdb::repo::yum',
            },
            'RedHat' => {
              'contain'     => 'influxdb::repo::yum',
              'not_contain' => 'influxdb::repo::apt',
            }
          }
        end

        let(:osfamily) { facts[:osfamily].to_s }
        let(:contained_class) { defined_repos[osfamily]['contain'] }
        let(:not_contained_class) { defined_repos[osfamily]['not_contain'] }

        it { is_expected.to contain_class(contained_class) }
        it { is_expected.to_not contain_class(not_contained_class) }

        it { is_expected.to contain_class('influxdb::repo') }
        it { is_expected.to compile }

      end

      describe 'should fail when not-supported OS' do
        let(:facts) do
          facts.merge({
            :osfamily => 'foobar',
          })
        end

        it { is_expected.to compile.and_raise_error(/Unsupported managed repository/) }
      end

   end
  end

end
