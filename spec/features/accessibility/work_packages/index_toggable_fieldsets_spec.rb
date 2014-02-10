#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2013 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'
require 'features/work_packages/work_packages_page'

describe 'Work package index' do
  describe 'Toggable fieldset' do
    let(:project) { FactoryGirl.create(:project) }
    let(:current_user) { FactoryGirl.create (:admin) }
    let(:work_packages_page) { WorkPackagesPage.new }
    let(:collapsed_class_name) { 'collapsed' }

    shared_context 'find legend with text' do
      let(:legend_text) { find('legend a', text: fieldset_name) }
      let(:fieldset) { legend_text.find(:xpath, '../..') }
    end

    shared_context 'find toggle label' do
      let(:toggle_state_label) { legend_text.find('span.fieldset-toggle-state-label', visible: false) }

      it { expect(toggle_state_label).not_to be_nil }
    end

    shared_examples_for 'toggle state set collapsed' do
      include_context 'find legend with text'
      include_context 'find toggle label'

      it { expect(toggle_state_label.text(:all)).to include(I18n.t('js.label_collapsed')) }
    end

    shared_examples_for 'toggle state set expanded' do
      include_context 'find legend with text'
      include_context 'find toggle label'

      it { expect(toggle_state_label.text(:all)).to include(I18n.t('js.label_expanded')) }
    end

    shared_examples_for 'collapsed fieldset' do
      include_context 'find legend with text'

      it { expect(fieldset[:class]).to include(collapsed_class_name) }
    end

    shared_examples_for 'expanded fieldset' do
      include_context 'find legend with text'

      it { expect(fieldset[:class]).not_to include(collapsed_class_name) }
    end

    before do
      User.stub(:current).and_return current_user

      work_packages_page.visit_index
    end

    describe 'Filter fieldset' do
      let(:fieldset_name) { 'Filters' }

      it_behaves_like 'expanded fieldset'

      describe 'initial state', js: true do
        include_context 'find legend with text'

        it_behaves_like 'toggle state set collapsed'
      end

      describe 'after click', js: true do
        include_context 'find legend with text'

        before { legend_text.click }

        it_behaves_like 'toggle state set expanded'
      end
    end

    describe 'Options fieldset' do
      let(:fieldset_name) { 'Options' }

      it_behaves_like 'collapsed fieldset'

      describe 'initial state', js: true do
        include_context 'find legend with text'

        it_behaves_like 'toggle state set expanded'
      end

      describe 'after click', js: true do
        include_context 'find legend with text'

        before { legend_text.click }

        it_behaves_like 'toggle state set collapsed'
      end
    end
  end
end
