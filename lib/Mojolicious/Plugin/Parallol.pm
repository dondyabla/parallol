package Mojolicious::Plugin::Parallol;

use Mojo::Base 'Mojolicious::Plugin';
use Scalar::Util 'weaken';

sub register {
  my ($plugin, $app) = @_;

  $app->hook(before_dispatch => sub {
    my $self = shift;
    $self->{paralloling} = 0;
    $self->attr(on_parallol => sub {
      sub {
        my $self = shift;
        $self->render unless $self->stash('mojo.finished');
      }
    });
  });
  
  $app->helper(
    parallol => sub {
      my ($self, $callback) = @_;
      weaken($self);

      $self->render_later;
      $self->{paralloling}++;

      sub {
        eval { $callback->(@_); 1 } or $self->render_exception($@);
        $self->on_parallol->($self) if --$self->{paralloling} == 0;
      }
    }
  );
}

"Parallolololololololololol";
