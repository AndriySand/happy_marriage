object false
node(:meta) do
                { :success => false,
                  :count => 1,
                  :totalCount => 1,
                  :countPerPage => 1,
                  :pageIndex => 1 }
            end
node :data do
  [ { :error => { :description => locals[:error_description] } } ]
end
