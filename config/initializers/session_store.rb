Community::Application.config.session_store :active_record_store, :key => '_community_session', :expire_after => 30.days
ActionDispatch::Session::ActiveRecordStore.session_class = Session