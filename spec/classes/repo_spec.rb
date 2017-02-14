require 'spec_helper'

describe 'influxdb::repo' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default params' do

        let(:contained_class) { get_repo_contain_class(facts) }
        let(:not_contained_class) { get_repo_not_contain_class(facts) }

        it { is_expected.to contain_class(contained_class) }
        it { is_expected.to_not contain_class(not_contained_class) }

        it { is_expected.to contain_class('influxdb::repo') }
        it { is_expected.to compile }

        # ordering tests
        it { is_expected.to contain_class(contained_class).that_comes_before('Class[influxdb::repo]') }

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
