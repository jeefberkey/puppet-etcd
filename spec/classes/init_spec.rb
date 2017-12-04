require 'spec_helper'

describe 'etcd' do
  on_supported_os.each do |os, facts|
    context "with defaults on #{os}" do
      let(:facts) do
        facts.merge({:puppetmaster => 'localhost.localdomain'})
      end

      context 'minimal parameters' do
        let(:params) { { :etcd_name => 'name' } }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('etcd') }
      end

      context 'example in readme' do
        let(:params) {{
          listen_client_urls: 'http://0.0.0.0:2379',
          advertise_client_urls: "http://${::fqdn}:2379,http://127.0.0.1:2379",
          listen_peer_urls: 'http://0.0.0.0:2380',
          initial_advertise_peer_urls: "http://${::fqdn}:2380,http://127.0.0.1:2379",
          initial_cluster: [
            "${::hostname}=http://${::fqdn}:2380",
            'infra1=http://infra1.domain.net:2380',
            'infra2=http://infra2.domain.net:2380'
          ]
        }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('etcd') }
      end

      context 'my usage' do
        let(:params) {{
          listen_client_urls: 'https://0.0.0.0:2379',
          advertise_client_urls: "https://${facts['fqdn']}:2379",
          listen_peer_urls: 'https://0.0.0.0:2380',
          etcd_name: 'default',
          client_cert_auth: true,
          peer_client_cert_auth: true,
          cert_file: "/etc/pki/simp-testing/pki/private/${facts['fqdn']}.pem",
          key_file: "/etc/pki/simp-testing/pki/private/${facts['fqdn']}.pem",
          trusted_ca_file: "/etc/pki/simp-testing/pki/cacerts/cacerts.pem",
          peer_cert_file: "/etc/pki/simp-testing/pki/private/${facts['fqdn']}.pem",
          peer_key_file: "/etc/pki/simp-testing/pki/private/${facts['fqdn']}.pem",
          peer_trusted_ca_file: "/etc/pki/simp-testing/pki/cacerts/cacerts.pem",
          initial_advertise_peer_urls: "https://${facts['fqdn']}:2380",
          initial_cluster: [ 'master01=https://master01:2380' ],
        }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('etcd') }
      end
    end
  end
end
