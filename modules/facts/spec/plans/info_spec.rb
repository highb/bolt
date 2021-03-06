# frozen_string_literal: true

require 'spec_helper'
require 'bolt_spec/plans'

describe 'facts::info' do
  include BoltSpec::Plans

  context 'an ssh target' do
    let(:node) { 'ssh://host' }

    it 'contains OS information for target' do
      expect_task('facts::bash').always_return('os' => { 'name' => 'unix', 'family' => 'unix', 'release' => {} })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq(["#{node}: unix  (unix)"])
    end

    it 'omits failed targets' do
      expect_task('facts::bash').always_return('_error' => { 'msg' => "Failed on #{node}" })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq([])
    end
  end

  context 'a winrm target' do
    let(:node) { 'winrm://host' }

    it 'contains OS information for target' do
      expect_task('facts::powershell').always_return('os' => { 'name' => 'win', 'family' => 'win', 'release' => {} })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq(["#{node}: win  (win)"])
    end

    it 'omits failed targets' do
      expect_task('facts::powershell').always_return('_error' => { 'msg' => "Failed on #{node}" })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq([])
    end
  end

  context 'a pcp target' do
    let(:node) { 'pcp://host' }

    it 'contains OS information for target' do
      expect_task('facts::ruby').always_return('os' => { 'name' => 'any', 'family' => 'any', 'release' => {} })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq(["#{node}: any  (any)"])
    end

    it 'omits failed targets' do
      expect_task('facts::ruby').always_return('_error' => { 'msg' => "Failed on #{node}" })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq([])
    end
  end

  context 'a local target' do
    let(:node) { 'local://' }

    it 'contains OS information for target' do
      expect_task('facts::bash').always_return('os' => { 'name' => 'any', 'family' => 'any', 'release' => {} })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq(["#{node}: any  (any)"])
    end

    it 'omits failed targets' do
      expect_task('facts::bash').always_return('_error' => { 'msg' => "Failed on #{node}" })

      expect(run_plan('facts::info', 'nodes' => [node])).to eq([])
    end
  end

  context 'ssh, winrm, and pcp targets' do
    let(:nodes) { %w[ssh://host1 winrm://host2 pcp://host3] }

    it 'contains OS information for target' do
      [
        ['facts::bash', { 'os' => { 'name' => 'unix', 'family' => 'unix', 'release' => {} } }],
        ['facts::powershell', { 'os' => { 'name' => 'win', 'family' => 'win', 'release' => {} } }],
        ['facts::ruby', { 'os' => { 'name' => 'any', 'family' => 'any', 'release' => {} } }]
      ].zip(nodes).each do |(task, result), node|
        expect_task(task).return_for_targets(node => result)
      end

      expect(run_plan('facts::info', 'nodes' => nodes)).to eq(
        ["#{nodes[0]}: unix  (unix)", "#{nodes[1]}: win  (win)", "#{nodes[2]}: any  (any)"]
      )
    end

    it 'omits failed targets' do
      %w[facts::bash facts::powershell facts::ruby].zip(nodes).each do |fact, node|
        expect_task(fact).return_for_targets(node => { '_error' => { 'msg' => "Failed on #{node}" } })
      end

      expect(run_plan('facts::info', 'nodes' => nodes)).to eq([])
    end
  end
end
