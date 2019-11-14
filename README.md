# 環境説明
  * ruby version on server 2.2.2
  * rails version 4.2.5
  * capistrano version 3.3.3
  で構成されています。

# 何が出来るの？
## メリット
  * プロジェクトは、ローカルで作成の後、サーバーにあげます。その際に良くエラーが起きるので、起きないようにした空プロジェクトです。
  * これをベースに開発すると、ストレスが減ります。

## デメリット
  * 古いものを使い続けることになります。

# ローカルでの使い方
  1. base_projectをクローン/アップデート
  2. githubにプロジェクトのリポジトリを作成
  3. git cloneする
  4. 出来たプロジェクトの所に、base_projectを丸々コピー
  5. basefile.rbのENV['APP_NAME']を新しいプロジェクト名に変更
  6. ローカルのmysqlにデータベースを作りましょう。daily-tasksのREADME見てね。
  

# いざサーバーへデプロイ！
  0. pp-gatewayで3つのファイルを変更する(chef-cookbooks-std内のrole,node,site-cookbooks>nginx>templete>defaultの3つ)
  1. knife solo prepare 〇〇 (chef-cookbooks-std直下で。nodeファイルと同じ名前で)
  2. knife solo cook 〇〇
  3. 本番サーバーで mysql -h  pocketpair-prod.cxexe4gd2td2.ap-northeast-1.rds.amazonaws.com -u pocketpair -p
  4. git clone 
  5. bundle install --path
  6. bundle exec cap production deploy
  7. bundle exec cap production unicorn:stopやstartやrestartで問題がないか確認

## 本番サーバーのmysqlの中
  create database 〇〇_production CHARACTER SET utf8mb4;
  SET NAMES utf8mb4;
  grant all on 〇〇_production.* to △△@'%';
  flush privileges;
  set password for △△@'%'=password('□□');